({
	getRecordTypeObjects : function(component) {
        var action =  component.get('c.getRecordTypes');
        action.setCallback(this, function(response){
            var state =  response.getState();
            if(state === 'SUCCESS'){
                component.set('v.recordTypes', response.getReturnValue());
                var options = [];

                for(var value in component.get('v.recordTypes')){
                    options.push({'label': component.get('v.recordTypes')[value].Name.replace(' Sales', ''), 'value': component.get('v.recordTypes')[value].Id});
                }
               component.set('v.options', options);
            }
        });
        $A.enqueueAction(action);
	},
    getHomeservices : function(component, recordId){
        //alert("Hs entra 1")
        var action = component.get('c.getHsFromAccount');
        action.setParams({
            "recordId" : recordId
        });
        action.setCallback(this, function(response){
            var state =  response.getState();
            if(state === 'SUCCESS'){
                var data=response.getReturnValue();
                //alert("Hs entra")
                console.log('Data####1')
                console.log(data)
                var hsId=component.get('v.HSrecordId')
                for(var i=0;i<data.length;i++){
                    //alert(hsId+" <-> "+data[i].Id);
                    if(hsId==data[i].Id){
                        //alert("Igual")
                        var aux=data[0];
                        data[0]=data[i];
                        data[i]=aux;
                        break;
                    }
                    
                }
                component.set('v.Home_Services', data); 
                
                if(response.getReturnValue().length > 0){
                    component.set("v.empty", false);
                }
            }
        });
        $A.enqueueAction(action);
        
    },
    saveHs : function(component, homeService){
        var action = component.get('c.saveHomeServiceInfo');
        action.setParams({
            "Home_Services" : homeService
        });
        action.setCallback(this, function(response){
            var state =  response.getState();
            if(state === 'SUCCESS'){
                var homeServices = component.get("v.Home_Services");
                homeServices.push(response.getReturnValue());
                component.set("v.Home_Services", homeServices);
                component.set("v.empty", false);
            }
        });
        $A.enqueueAction(action);
    },
    getRecordHS : function(component, recordId){
        //alert("Hs entra 1")
        var action = component.get('c.getHSContract');
        action.setParams({
            "recordId" : recordId
        });
        action.setCallback(this, function(response){
            var state =  response.getState();
            if(state === 'SUCCESS'){
                var data=response.getReturnValue();
                component.set('v.HSId', data)
            }
        })
        $A.enqueueAction(action);
    }
})