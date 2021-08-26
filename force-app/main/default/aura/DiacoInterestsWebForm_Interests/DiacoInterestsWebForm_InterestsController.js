({
    doInit : function(cmp, event, helper) {

        if( cmp.get('v.open') ) {

            let interests = cmp.get('v.interests');
            let interestSelected =  cmp.get('v.interestSelected');
            for (let i = 0; i < interests.length; i++) {
                let findInterest = interestSelected.find(item => item === interests[i].name); 
                interests[i].checked = findInterest ? true : false;
            }
        }
    },  

    closeModel : function(cmp, event, helper) {
        cmp.get('v.interestSelected',[]);
        cmp.set('v.open', false);
    },

    handlerSubmit:  function(cmp, event, helper) {

        const createEvent = cmp.getEvent('listInterestSelected');
        createEvent.setParams({ 'interestSelected'    : cmp.get('v.interestSelected'),});
        createEvent.fire();

        cmp.get('v.interestSelected',[]);
        cmp.set('v.open', false);
    },

    handlerSelectInterest : function(cmp, event, helper) {

        const interestBox = event.getParam('interestBox');
        if( interestBox ) {

            var interestSelected = cmp.get('v.interestSelected');

            if( interestBox.checked ) {

                interestSelected.push(interestBox.name);
            }else {

                let index = interestSelected.indexOf(interestBox.name);
                if ( index > -1 ) {
                    interestSelected.splice(index, 1);
                }
            }

            cmp.set('v.interestSelected',interestSelected);
        }
    },
})