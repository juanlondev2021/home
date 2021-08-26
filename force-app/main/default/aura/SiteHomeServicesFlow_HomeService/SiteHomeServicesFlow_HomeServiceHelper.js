({

    setColumns : function(cmp) {

        var data = cmp.get('v.data');
        let baseUrl = 'https://myhomeservices.lightning.force.com'; 
        for (var i = 0; i < data.length; i++) {

            data[i].HomeServiceName = data[i].Name == undefined ? '' : data[i].Name;
            data[i].HomeServiceUrl = baseUrl + '/lightning/r/Home_Services__c/' + data[i].Id + '/view';
            data[i].EventUrl = data[i].Event__c == undefined ? '' : baseUrl + '/lightning/r/Event/' + data[i].Event__c + '/view';
            data[i].Industry = data[i].RecordType == undefined ? '' : data[i].RecordType.Name;
            data[i].HomeServiceStatus = data[i].Home_Services_Status__c == undefined ? '' : data[i].Home_Services_Status__c;
            data[i].NameEvent = data[i].Name;
        }

        cmp.set('v.data', data);
        
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

        fields.push({
            label: 'Current Event', fieldName: 'EventUrl', type: 'url',
            typeAttributes: {
                target: '_blank',
                label: { fieldName: 'NameEvent' }
            }
        });
        
        if (device == 'DESKTOP') {
            fields.push({ label: 'Type', fieldName: 'Industry', type: 'text' })
            fields.push({ label: 'Home Services Status', fieldName: 'HomeServiceStatus', type: 'text' });
        }
        //fields.push({ fieldName: 'Industry', type: 'action', typeAttributes: { rowActions: actions } });

        cmp.set('v.columns', fields);

        cmp.set('v.loaded', false);

    },
});