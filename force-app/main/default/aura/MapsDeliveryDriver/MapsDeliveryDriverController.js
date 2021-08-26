({
    doInit : function(cmp, event, helper) {
        helper.getRouters(cmp);
        helper.getGeoLocation(cmp)
    },

    selectRoute : function(cmp, event, helper){
        let routeId = event.target.id;
        //console.log('>> routeId  ' + routeId);
        const route = cmp.get('v.routes').find( item => item.Id === routeId);
        if( route ) {
            cmp.set('v.route',route);
            cmp.set('v.openRoute',true);
            //alert('>> current route  ' + JSON.stringify(cmp.get('v.route')));
            let cmpRoute = cmp.find('cmpRoute');
            if(cmpRoute){
                cmpRoute.init();
            }
        } 
    },

    closeRoute : function(cmp,event,helper) {
        cmp.set('v.openRoute',false);
    }
})