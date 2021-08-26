({
    doInit: function(cmp, event, helper) {

        cmp.set("v.isLoad", true);        
        cmp.set('v._label', 'unsaved');

        helper.getDataCustomer(cmp, cmp.get("v.recordId"));
        helper.getOptions(cmp, cmp.get('v.apiNames'));

    },

    handlerSave : function(cmp, event, helper ) {

        var customerAlarm = cmp.get('v.customerAlarm');

        if( helper.validateFieldsForm(cmp,customerAlarm) ) {
            
            cmp.set('v.isLoad', true);
            if( cmp.get('v.DiacoAlarm__DiacoCsEventGroupsToForward_values').length > 0 ) {

                customerAlarm.DiacoAlarm__DiacoCsEventGroupsToForward__c = cmp.get('v.DiacoAlarm__DiacoCsEventGroupsToForward_values').join(';');
            }else {

                customerAlarm.DiacoAlarm__DiacoCsEventGroupsToForward__c = [];
            }
            //console.log(JSON.stringify(customerAlarm));
            let action = cmp.get('v.isCustomUpdate') ? 'update' : 'insert';
            helper.saveInformation(cmp,customerAlarm, action);
        }

    },

    onChangeSameAddress: function (cmp, evt, helper) {

        var customerAlarm = cmp.get('v.customerAlarm');
        let active = customerAlarm.DiacoAlarm__DiacoSameContactAddress__c;
        cmp.set("v.sameAddressField", active);
        
        if ( active ) {

            customerAlarm.DiacoAlarm__DiacoCity__c      = customerAlarm.DiacoAlarm__DiacoCityAddressWithName__c;
            customerAlarm.DiacoAlarm__DiacoState__c     = customerAlarm.DiacoAlarm__DiacoStateAddressWithName__c;
            customerAlarm.DiacoAlarm__DiacoZipCode__c   = customerAlarm.DiacoAlarm__DiacoZipCodeAddressWithName__c;
            customerAlarm.DiacoAlarm__DiacoStreet1__c   = customerAlarm.DiacoAlarm__DiacoStreet1AddressWithName__c,
            customerAlarm.DiacoAlarm__DiacoStreet2__c   = customerAlarm.DiacoAlarm__DiacoStreet2AddressWithName__c;
            customerAlarm.DiacoAlarm__DiacoCountryId__c = customerAlarm.DiacoAlarm__DiacoCountryIdAddressWithName__c;

        }else{
            if( cmp.get('v._label') != 'Saved' ) {
                customerAlarm.DiacoAlarm__DiacoCity__c      = '';
                customerAlarm.DiacoAlarm__DiacoState__c     = '';
                customerAlarm.DiacoAlarm__DiacoZipCode__c   = '';
                customerAlarm.DiacoAlarm__DiacoStreet1__c   = '',
                customerAlarm.DiacoAlarm__DiacoStreet2__c   = '';
                customerAlarm.DiacoAlarm__DiacoCountryId__c = '';
            }
        }
        cmp.set('v.customerAlarm',customerAlarm);
    }
})