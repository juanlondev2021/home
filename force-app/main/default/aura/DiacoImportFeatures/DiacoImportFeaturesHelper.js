({
    GetRecords : function(component,id) {
        var action = component.get('c.GetCsvData');

        action.setParams({
            contentdocumentId:id
        });

        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                const responseValue = response.getReturnValue();
                console.log(responseValue);
                let repeat = [];
                let norepeat = [];
                responseValue.forEach(function(elem,index,array) {
                    let result = responseValue.slice(index).filter(elem1 => (elem1.Firstname==elem.Firstname && elem1.Lastname==elem.Lastname) || (elem1.address==elem.address));
                    if (result.length==1){
                        norepeat.push(result[0]); 
                    }else{
                        repeat = repeat.concat(result);
                        let flat = true;
                        result.forEach(elem2 => {
                            if (flat) {
                                responseValue.splice(responseValue.indexOf(elem2),1,'');
                                flat=false;
                            }else responseValue.splice(responseValue.indexOf(elem2),1);
                        });  
                    }
                })
                console.log('norepeat',norepeat.length);
                console.log('repeat',repeat.length);
                component.set('v.ObjectsList',norepeat);
                component.set('v.ObjectsListR',repeat);
            }else{
                this.responseErrorHandling(component,response,'Error on file Upload');
            }
            component.set("v.loaded",false);
        });
        $A.enqueueAction(action);
    },
    insertRecords : function(component,Accounts,Address,Uaddress,mode){
        var action = component.get("c.recordsInsert");

        action.setParams({
            accounts:Accounts,
            address:Address,
            uaddress:Uaddress,
            options:mode
        });

        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                component.find('notifLib').showToast({
                    "title": "Success",
                    "message": 'insert process started correctly',
                    "variant":"info"
                });
                component.set('v.ObjectsList',[]);
                component.set('v.ObjectsListR',[]);
                component.set('v.ObjectsListS',[]);
                
            }else{
                this.responseErrorHandling(component,response,'Error Creating Records');
            }
            component.set("v.loaded",false);
        });

        $A.enqueueAction(action);
    },
    handleInsert: function (component, mode){
        component.set("v.ConfirmModal",false);
        component.set("v.loaded",true);
        let Accts = [];
        let Address = [];
        let Uaddress = [];
        let uni = component.get("v.ObjectsList");
        let select = component.get("v.ObjectsListS");
        let total = uni.concat(select);
        total.forEach(item =>{
            let account = {
                FirstName:item.Firstname, LastName:item.Lastname, 
                City__c:item.city, County__c: item.County, Down_Payment__c:item.Down,
                FileNumber__c:item.FileNumber, Home_Type__c:item.Hometype, New__c: (item.iNew=='N'?true:false),
                Recording_Date__c:item.iDATE,Sales_Price__c:item.SalePrice, State__c:item.state, 
                Street__c:item.address, Zip__c: item.zip
            };
            Accts.push(account);
            let address = {
                City__c:item.city,County__c:item.County, Data_Provider__c: "ION",
                FileNumber__c:item.FileNumber, Home_Type__c: item.Hometype,
                State__c:item.state, Street__c:item.address, Zip_Code__c:item.zip
            };
            Address.push(address);
            let uaddress = {
                Active__c:true,Data_Provider_ID__c:"ION",Down_Payment__c:item.Down,FileNumber__c:item.FileNumber,
                New__c:(item.iNew='N'?true:false),Recording_Date__c:item.iDATE,Sales_Price__c:item.SalePrice,
                Start_Date__c:item.iDATE,User_Address_Type__c:"Primary Owner"
            };
            Uaddress.push(uaddress);
        });
        this.insertRecords(component,Accts,Address,Uaddress,mode);
    },
    createDeliveries: function(component){
        var action = component.get("c.createDeliveries");

        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                component.find('notifLib').showToast({
                    "title": "Success",
                    "message": 'request to create deliveries sent successfully',
                    "variant":"success"
                });
            }else{
                this.responseErrorHandling(component,response,'Error Creating Deliveries');
            }
            component.set("v.loaded",false);
        });

        $A.enqueueAction(action);
    },
    responseErrorHandling: function (component,response,toastMessage) {
        component.find('notifLib').showToast({
            "title": "Error",
            "message": toastMessage,
            "variant":"error"
        });
        
        let errors = response.getError();
        let message = 'Unknown error'; // Default error message
        // Retrieve the error message sent by the server
        if (errors && Array.isArray(errors) && errors.length > 0) {
            message = errors[0].message;
        }
        // Display the message
        console.log("Response error handling")
        console.error(message);
        
    }
})