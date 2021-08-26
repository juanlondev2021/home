({
    gettingLineItems: function (component, recordId) {
        var action = component.get("c.getLineItemsServices");
        action.setParams({
            'recordId': recordId
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var ois = response.getReturnValue();

                if ( ois.length > 0) {
                    let selectedFrequency = ois[0].Billing_Frequency__c != undefined ? ois[0].Billing_Frequency__c : '';
                    let billStartDate =  ois[0].Bill_Start_Date__c != undefined ? $A.localizationService.formatDateUTC(new Date(ois[0].Bill_Start_Date__c),"yyyy-MM-dd") : undefined;
                    
                    component.set('v.selectedFrequency', selectedFrequency);
                    component.set('v.billStartDate',billStartDate);
                    component.set('v.originalSelectedFrequency', selectedFrequency);
                }

                var totalInvestment = 0;
                for (var i = 0; i < ois.length; i++) {
                    ois[i].IdRow = "row-" + i;
                    ois[i].OIUrl = window.location.hostname + '/lightning/r/Order_Item__c/' + ois[i].Id + '/view'
                    totalInvestment += ois[i].Monthly_Investment__c;
                    // ois[i].TotalPrice = ois[i].Quantity__c * ois[i].Price__c; 
                }
                component.set('v.totalInvestment', totalInvestment);
                component.set('v.originalTotalInvestment', totalInvestment);

                this.setColumns(component);

                component.set('v.data', ois);
                component.set('v.originalData', JSON.parse(JSON.stringify(ois)));
                component.set('v.isLoad', false);
                
                var tabEvent = component.getEvent("tabSaved");
                tabEvent.setParams({ "tabName": 'products-services' });
                tabEvent.fire();
            } 
        })
        $A.enqueueAction(action);
    },

    deletingOrderItem: function (component, recordId) {
        var action = component.get("c.deleteLineItem");
        action.setParams({
            'recordId': recordId
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "Services has been REMOVED successfully.",
                    "type": "success"
                });
                toastEvent.fire();
                this.gettingLineItems(component, component.get('v.recordId'));
            } else {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Error trying to remove Services.",
                    "type": "error"
                });
                toastEvent.fire();
            }
        })
        $A.enqueueAction(action);
    },

    gettingServices: function (component, recordId) {
        var action = component.get("c.getServices");
        action.setParams({
            'recordId': recordId
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var ois = response.getReturnValue();
                for (var i = 0; i < ois.length; i++) {
                    ois[i].label = ois[i].Name;
                    ois[i].value = ois[i].Id;
                }

                // component.set('v.lenCO',cos.length+1);
                component.set('v.options', ois);

            } else {

            }
            component.set('v.isLoadP', false);
        })
        $A.enqueueAction(action);
    },

    handleSaveEdition: function (component, data) {
        var action = component.get("c.updateLineItems");
        action.setParams({
            'recordToUpdate': data
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "Services were UPDATE successfully.",
                    "type": "success"
                });
                toastEvent.fire();
                var ois = component.get('v.data');

                component.set('v.originalData', JSON.parse(JSON.stringify(ois)));

                component.set('v.originalSelectedFrequency', component.get('v.selectedFrequency'));

                component.set('v.originalTotalInvestment', component.get('v.totalInvestment'));

                // reload
                this.gettingLineItems(component, component.get('v.recordId'));

            } else {
                var toastEvent = $A.get("e.force:showToast");
                console.log(response.getError())
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Line Items were NOT UPDATED successfully.",
                    "type": "error"
                });
                toastEvent.fire();

            }
            component.set('v.isLoad', false);
        })
        $A.enqueueAction(action);
    },

    addServices: function (component, iCO, s) {
        var action = component.get("c.addServicesToHS");
        var frequency = component.get('v.selectedFrequency');
        action.setParams({
            'recordId': iCO,
            'selectedOptions': s,
            'frequency': frequency
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.isOpen', false);
                var action1 = component.get("c.doInit");
                $A.enqueueAction(action1);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "Services were added successfully.",
                    "type": "success"
                });
                toastEvent.fire();
                component.set("v.selectedOptions", []);

            } else {
                component.set('v.isOpen', false);
                console.log(response.getError())
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Services were NOT added successfully.",
                    "type": "error"
                });
                toastEvent.fire();
                component.set("v.selectedOptions", []);
            }
        })
        $A.enqueueAction(action);
    },

    updateBillingFrecuencyMobile: function (component) {
        var action = component.get("c.updatePaymentItemsServices");
        var frequency = component.get('v.selectedFrequency');
        var recordId = component.get('v.recordId');
        action.setParams({
            'recordId': recordId,
            'newBillingFrecuency': frequency
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "Services were updated successfully.",
                    "type": "success"
                });
                toastEvent.fire();
                this.gettingLineItems(component, recordId);
                component.set("v.updateBillingFrecuency", false);

            } else {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": "Services were NOT updated successfully.",
                    "type": "error"
                });
                toastEvent.fire();
            }
        })
        $A.enqueueAction(action);
    },

    setColumns : function(component) {
        var InvestmentTitle = component.get('v.selectedFrequency') + ' Investment';

        var actions = [
            { label: 'Delete', name: 'delete' }
        ];

        var device = $A.get("$Browser.formFactor");
        var columns = [
            { label: 'Name', fieldName: 'OIUrl', type: 'url', initialWidth: device == 'DESKTOP' ? undefined : 190, typeAttributes: { target: '_blank', label: { fieldName: 'Name' } } }
        ];

        if (device == 'DESKTOP') {
            columns.push({ label: 'Bill Start Date', fieldName: 'Bill_Start_Date__c', editable: false, type: 'date-local', initialWidth: device == 'DESKTOP' ? undefined : 120 });
            columns.push({ label: 'Billing Frequency', fieldName: 'Billing_Frequency__c', type: 'text', initialWidth: device == 'DESKTOP' ? undefined : 120 });
            columns.push({
                label: InvestmentTitle, fieldName: 'Monthly_Investment__c', type: 'currency', initialWidth: device == 'DESKTOP' ? undefined : 150, editable: true, typeAttributes:
                    { required: true }
            });
        } else {
            columns.push({ label: 'View', type: 'button', initialWidth: 100, typeAttributes: { label: 'Details', name: 'view_details', title: 'Click to View Details' } });
        }
        columns.push({
            fieldName: 'deleteButton', type: 'button-icon', initialWidth: 20, typeAttributes:
                { variant: 'bare', title: 'Click to delete Service', name: 'delete', iconName: 'utility:delete', size: 'large' }
        });

        component.set('v.columns', columns);
    },
})