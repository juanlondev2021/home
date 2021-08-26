({
    doInit: function (cmp, event, helper) {
        
        cmp.set('v.loaded', true);
        let assigned = event.getParam('assigned');
        cmp.set('v.assiged', assigned != undefined ? assigned : false);

        helper.getDataHomeServices(cmp);
    },
})