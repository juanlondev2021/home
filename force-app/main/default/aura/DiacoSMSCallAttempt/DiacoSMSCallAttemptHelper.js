({
    getHomeService :  function(cmp) {

        var action = cmp.get("c.getData");
        action.setParams({
            "confirmationNum": cmp.get("v.confirmationNum"),     
        });
    
        action.setCallback(this, function(response) {
    
            var state = response.getState();
            if( state === 'SUCCESS' ) {
            
                const data =  response.getReturnValue();
                console.log('>DateResponse ', data); 
                if( data.success ) {                    
                    let homeServices =  data.homeServices;
                    for (let i = 0; i < homeServices.length; i++) {
                        homeServices[i].Confirmation_Call_Count__c = homeServices[i].Confirmation_Call_Count__c != undefined ? homeServices[i].Confirmation_Call_Count__c : '0';
                        homeServices[i].urlName = cmp.get('v.urlBase')+homeServices[i].Id;
                    }
                    cmp.set('v.data', homeServices);
                    cmp.set('v.account', data.account);
                    this.setColums(cmp);
                }else {
                    //this.showMessage(data.message, 'error'); 
                }    
            } else {
    
                let errors = response.getError();
                let message = 'Unknown error'; // Default error message
                // Retrieve the error message sent by the server
                if ( errors && Array.isArray(errors) && errors.length > 0 ) {
                    message = errors[0].message;
                }
                // Display the message
                console.error(message);
    
                this.showMessage('something went wrong. ' + message, 'error');
            }
            cmp.set('v.loaded',false);            
        });
        
        $A.enqueueAction(action);				        
    },


    setColums : function(cmp) {
        let fields;


        let device = $A.get("$Browser.formFactor");
        if( device == 'DESKTOP') {
            //DESKTOP
            fields = [   
                {label: 'Home Service', fieldName: 'urlName', type: 'url', wrapText:true,
                typeAttributes: { target: '_blank',                               
                                label: { fieldName: 'Name' },
                                tooltip: { fieldName: 'Name' }}},         
                { label: 'Confirmation Call Status', fieldName: 'Confirmation_Call_Status__c', type: 'text',
                cellAttributes:{ class: {fieldName: 'green'} }
                },
                { label: 'Confirmation Call Count', fieldName: 'Confirmation_Call_Count__c', type: 'text' },
                {label: 'SMS', fieldName: "SMS", type: 'button-icon', initialWidth: 5, 
                typeAttributes: { name: 'SMS', 
                                    class: { fieldName: 'blue' },
                                    variant: 'bare', 
                                    title: 'Click to send SMS',
                                    iconName:'utility:send',
                                    size:'large' } }
            ];
        }else {
        //PHONE
            fields = [   
                {label: 'Home Service', fieldName: 'urlName', type: 'url', wrapText:true,
                typeAttributes: { target: '_blank',                               
                                label: { fieldName: 'Name' },
                                tooltip: { fieldName: 'Name' }}},
                {label: 'Detail', fieldName: "Detail", type: 'button-icon', initialWidth: 5, 
                typeAttributes: { name: 'Detail', 
                                    class: { fieldName: 'blue' },
                                    variant: 'bare', 
                                    title: 'Click to more info',
                                    iconName:'utility:rows',
                                    size:'large' } }
            ];
        }
        cmp.set('v.columns', fields);
    },

    generateSMS :  function(cmp) {

        var action = cmp.get("c.sendSMSTo");
        action.setParams({
            "homeService": cmp.get('v.homeService'),     
        });
    
        action.setCallback(this, function(response) {
    
            var state = response.getState();
            if( state === 'SUCCESS' ) {
            
                const data =  response.getReturnValue();
                console.log('>DateResponse ', data); 
                if( data.success ) {
                    console.error(data.message);
                    this.showMessage(data.message, 'success'); 
                }else {
                    this.showMessage(data.message, 'error'); 
                }    
            } else {
    
                let errors = response.getError();
                let message = 'Unknown error'; // Default error message
                // Retrieve the error message sent by the server
                if ( errors && Array.isArray(errors) && errors.length > 0 ) {
                    message = errors[0].message;
                }
                // Display the message
                console.error(message);
    
                this.showMessage('something went wrong. ' + message, 'error');
            }
            cmp.set('v.loaded',false);            
        });
        
        $A.enqueueAction(action);				        
    },

    showMessage: function (msg, type) {
    
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type": type,
            "title": type === 'error' ? 'Error' : type === 'success' ? 'Successful' : 'Info',
            "message": msg
        });
        toastEvent.fire();
        //this.showMessage('The record has been saved successfully.', 'success');    
        //this.showMessage('Something went wrong.', 'error'); 
    }

})