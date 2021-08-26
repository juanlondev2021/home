({
    //Deprecated previous version only worked for the last pre design envelope associated to the Home service Id
    gettingSignedContract: function (component, recordId) {
        var action = component.get('c.signedContract');
        action.setParams({
            'recordId': recordId,
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                let data = response.getReturnValue();
                if (data !== null) {
                    component.set('v.filesContractId', data);
                } else {
                    component.set('v.itWasSigned', false);
                }
            } else {
                let errors = response.getError();
                let message = 'Unknown error'; // Default error message
                // Retrieve the error message sent by the server
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    if (Object.keys(errors[0].fieldErrors).length > 0) {
                        message = errors[0].fieldErrors[Object.keys(errors[0].fieldErrors)[0]][0].message;
                        console.log(message);
                    }

                }
                console.log(errors);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    mode: "sticky",
                    title: "Error!",
                    message: "Message: " + message,
                    type: "error"
                });
                toastEvent.fire();
            }
            component.set("v.isLoading", false);
        });

        $A.enqueueAction(action);

    },

    gettingSignedContractByName: function (component, recordId, PreDesignName) {
        var action = component.get('c.signedContractByName');
        action.setParams({
            'recordId': recordId,
            'preEnvName': PreDesignName
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                let data = response.getReturnValue();

                if (data !== null) {

                    component.set('v.filesContractId', data);
                } else {
                    component.set('v.itWasSigned', false);
                }
            } else {
                let errors = response.getError();
                let message = 'Unknown error getting signedContractByName'; // Default error message
                // Retrieve the error message sent by the server
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    if (Object.keys(errors[0].fieldErrors).length > 0) {
                        message = errors[0].fieldErrors[Object.keys(errors[0].fieldErrors)[0]][0].message;
                        console.log(message);
                    }

                }
                console.log(errors);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    mode: "sticky",
                    title: "Error!",
                    message: "Message: " + message,
                    type: "error"
                });
                toastEvent.fire();
            }
            component.set("v.isLoading", false);
        });

        $A.enqueueAction(action);

    },
    //this method is meant for the previous contracts, now it'll use the new method so the pre designenvelop name will be the recordType
    gettinSignedContractAndRecordTypeName: function (component, recordId) {
        var action = component.get("c.getRecordTypeFromHS");
        action.setParams({
            "RecordId": recordId,
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if (response.getReturnValue() != null) {

                    var recordType = response.getReturnValue();
                    if (recordType != null) {
                        if (recordType.includes('Home Automation')) {
                            recordType = 'Home Automation';
                            if(component.get('v.IsPinnacleFinance')){
                                recordType = 'Pinnacle Contract';
                            }
                        } else if (recordType.includes('Solar')) {
                            recordType = 'Solar';
                        } else if (recordType.includes('Water')) {
                            recordType = 'Water Treatment';
                        } else if (recordType.includes('Pest Control')) {
                            recordType = 'Pest Control';
                        } else if (recordType.includes('Remodel')) {
                            recordType = 'Remodel';
                        }
                    }

                    this.gettingSignedContractByName(component, recordId, recordType);
                }
            }
        });
        $A.enqueueAction(action);
    },
})