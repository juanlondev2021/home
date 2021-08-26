({
    setColumns : function(cmp) {

        var data = cmp.get('v.data');
        let baseUrl = 'https://myhomeservices.lightning.force.com'; 
        for (var i = 0; i < data.length; i++) {

            data[i].Name = data[i].Name == undefined ? '' : data[i].Name;
            data[i].urlName = baseUrl + '/lightning/r/' + data[i].Id + '/view';
            //data[i].Industry = data[i].RecordType == undefined ? '' : data[i].RecordType.Name;
            data[i].color = data[i].assigned__c  ? 'gray' : 'blue';
        }
        
        cmp.set('v.data', data);

        var fields = [
            {
                label: 'Name', fieldName: 'urlName', type: 'url',
                typeAttributes: {
                    target: '_blank',
                    label: { fieldName: 'Name' }
                },
            },
            
            { label: 'Status', fieldName: 'Status__c', type: 'text' },

            {
                fieldName: "edit", type: 'button-icon',
                typeAttributes: {
                    name: 'edit',
                    class: { fieldName: 'color' },
                    variant: 'bare',
                    title: 'Click to edit Appointment',
                    iconName: 'utility:edit',
                    size: 'large'
                }
            }
        ];

        cmp.set('v.columns', fields);
        cmp.set('v.loaded', false);
    },

})