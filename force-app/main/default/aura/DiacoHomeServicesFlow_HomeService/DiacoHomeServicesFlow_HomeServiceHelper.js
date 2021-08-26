({

    setColumns : function(cmp) {

        var data = cmp.get('v.data');

        console.table(data);

        for (var i = 0; i < data.length; i++) {

            data[i].HomeServiceName = data[i].Name == undefined ? '' : data[i].Name;
            data[i].HomeServiceUrl = window.location.hostname + '/lightning/r/Home_Services__c/' + data[i].Id + '/view';
            data[i].EventUrl = data[i].Event__c == undefined ? '' : window.location.hostname + '/lightning/r/Event/' + data[i].Event__c + '/view';
            data[i].Industry = data[i].RecordType == undefined ? '' : data[i].RecordType.Name;
            data[i].HomeServiceStatus = data[i].Home_Services_Status__c == undefined ? '' : data[i].Home_Services_Status__c;
            data[i].NameEvent = data[i].Name;
        }

        cmp.set('v.data', data);

        console.table(cmp.get('v.data'));

        var actions = [
            { label: 'Edit Home Service', name: 'edit_hs' },
            { label: 'Create Event', name: 'create_event' },
            { label: 'Contract', name: 'contract' }
        ];
        var device = $A.get("$Browser.formFactor");

        var fields = [
            {
                label: 'Home Services', fieldName: 'HomeServiceUrl', type: 'url',
                typeAttributes: {
                    target: '_blank',
                    label: { fieldName: 'HomeServiceName' }
                }
            },
        ];

        if (device == 'DESKTOP') {
            fields.push({
                label: 'Current Event', fieldName: 'EventUrl', type: 'url',
                typeAttributes: {
                    target: '_blank',
                    label: { fieldName: 'NameEvent' }
                }
            })
            fields.push({ label: 'Type', fieldName: 'Industry', type: 'text' })
            fields.push({ label: 'Home Services Status', fieldName: 'HomeServiceStatus', type: 'text' });
        }
        fields.push({ fieldName: 'Industry', type: 'action', typeAttributes: { rowActions: actions } });

        cmp.set('v.columns', fields);

        cmp.set('v.loaded', false);

    },

    gettingDataEvent: function (cmp, eventId) {
        var action = cmp.get("c.getDataEvent");
        action.setParams({
            'eventId': eventId
        });
        console.log(eventId);
        action.setCallback(this, function (response) {
            console.log(response.getState());
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set('v.event', response.getReturnValue());
                console.log(response.getReturnValue());
            }
        })
        $A.enqueueAction(action);
    },

    getWebForm: function (cmp, recordId) {
        var action = cmp.get("c.getWebform");
        action.setParams({
            'recordId': recordId
        });
        action.setCallback(this, function (response) {
            console.log(response.getState());
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                if (data.Start_DateTime__c != undefined &&
                    data.Start_DateTime__c != null) {
                    cmp.set('v.webForm', response.getReturnValue());
                    cmp.set('v.hasEventInfo', true);
                }

                console.log(response.getReturnValue());
            }
        })
        $A.enqueueAction(action);
    }
})