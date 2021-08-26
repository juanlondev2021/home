({
	gettingHomeServices : function(component) {
        var maxP = 100;
        var action = component.get("c.getHomeServices");
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                var industries = {'Pool Maintenance': 'Aqua Bright Water', 'Water Treatment': 'Aqua Bright Water',
                                  'Home Automation': 'Protection Source',
                                  'Garage Doors': 'Latch', 'Internet-Cable-Satelite': 'Latch', 'Lock Smith': 'Latch', 
                                  'Maid Service': 'Latch', 'Remodel': 'Latch', 'Carpet & Tile Cleaning': 'Latch', 
                                  'Garage Floor Coating': 'Latch',
                                  'Pest Control': 'Jax Pest Control',
                                  'Solar': 'N-Ergy',
                                  'HVAC': 'Rescue On Air'
                                 };
                var data = response.getReturnValue();
                var cont = 0;
                for (var i = 0; i < data.length; i++){
                    
                    data[i].IdRow = "row-"+cont;
                    cont = (cont == (maxP - 1)) ? 0 : cont + 1;
                    
                    data[i].HSUrl = window.location.hostname + '/lightning/r/Home_Services__c/' + data[i].Id + '/view';
                    data[i].Marketing = data[i].Marketing__c;
                    data[i].Data = data[i].Data__c;
                    data[i].Appointment = data[i].Appointment__c;
                    data[i].Hot_Lead = data[i].Hot_Lead__c;
                    
                    if (!data[i].hasOwnProperty("Home_Services_Status__c")) {
                        data[i].Home_Services_Status__c = null;
                    }
                    
                    if (!data[i].hasOwnProperty("Revenue_Note__c")) {
                        data[i].Revenue_Note__c = null;
                    }
                    
                    try {
                        data[i].industry = industries[data[i].Industry_Formula__c];
                    }
                    catch(error) {
                        console.log(error);
                    }
                }
                
                component.set("v.allData", data);
                var newOptions = data.slice(0, maxP);
                component.set("v.data", newOptions);
                component.set("v.originalData", JSON.parse(JSON.stringify(newOptions)));
                
                var pa = data.length != 0 ? data.length / maxP : 1;
                component.set("v.totalPages", parseInt(pa) + (Number.isInteger(pa) ? 0 : 1) );
                
            }else{
                var toastEvent = $A.get("e.force:showToast");
                 toastEvent.setParams({
                     "title": "Error!",
                     "message": "Error trying load data.",
                     "type":"error"
                 });
                 toastEvent.fire();
            }
            component.set("v.isLoading", false);
            
        })
        $A.enqueueAction(action);
	},
    
    gettingFilterHomeServices : function(component, data, dateFrom, dateTo) {
        var maxP = 100;
        var action = component.get("c.getFilterHomeServices");
        
        action.setParams({
            'data': data,
            'dateFrom': dateFrom,
            'dateTo': dateTo
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                var industries = {'Pool Maintenance': 'Aqua Bright Water', 'Water Treatment': 'Aqua Bright Water',
                                  'Home Automation': 'Protection Source',
                                  'Garage Doors': 'Latch', 'Internet-Cable-Satelite': 'Latch', 'Lock Smith': 'Latch', 
                                  'Maid Service': 'Latch', 'Remodel': 'Latch', 'Carpet & Tile Cleaning': 'Latch', 
                                  'Garage Floor Coating': 'Latch',
                                  'Pest Control': 'Jax Pest Control',
                                  'Solar': 'N-Ergy',
                                  'HVAC': 'Rescue On Air'
                                 };
                
                var data = response.getReturnValue();
                var cont = 0;
                for (var i = 0; i < data.length; i++){
                    
                    data[i].IdRow = "row-"+cont;
                    cont = (cont == (maxP - 1)) ? 0 : cont + 1;
                    
                    data[i].HSUrl = window.location.hostname + '/lightning/r/Home_Services__c/' + data[i].Id + '/view';
                    data[i].Marketing = data[i].Marketing__c;
                    data[i].Data = data[i].Data__c;
                    data[i].Appointment = data[i].Appointment__c;
                    data[i].Hot_Lead = data[i].Hot_Lead__c;
                    
                    if (!data[i].hasOwnProperty("Home_Services_Status__c")) {
                        data[i].Home_Services_Status__c = null;
                    }
                    
                    if (!data[i].hasOwnProperty("Revenue_Note__c")) {
                        data[i].Revenue_Note__c = null;
                    }
                    
                    try {
                        data[i].industry = industries[data[i].Industry_Formula__c];
                    }
                    catch(error) {
                        console.log(error);
                    }
                }
                
                component.set("v.allData", data);
                var newOptions = data.slice(0, maxP);
                component.set("v.data", newOptions);
                component.set("v.originalData", JSON.parse(JSON.stringify(newOptions)));
                
                var pa = data.length != 0 ? data.length / maxP : 1;
                component.set("v.selectedPage", 1);
                component.set("v.totalPages", parseInt(pa) + (Number.isInteger(pa) ? 0 : 1) );
                
            }else{
                var toastEvent = $A.get("e.force:showToast");
                 toastEvent.setParams({
                     "title": "Error!",
                     "message": "Error trying load data.",
                     "type":"error"
                 });
                 toastEvent.fire();
            }
            component.set("v.isLoading", false);
            
        })
        $A.enqueueAction(action);
	},
    
    updatingHomeServices : function(component, recordsToSave) {
        var maxP = 100;
        var action = component.get("c.updateHomeServices");
        action.setParams({
            'HS': recordsToSave
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                var data = component.get('v.data');
                component.set('v.originalData', JSON.parse(JSON.stringify(data)));
                component.set('v.allDraftValues', []);

                var toastEvent = $A.get("e.force:showToast");
                 toastEvent.setParams({
                     "title": "Success!",
                     "message": "Home Services were UPDATED successfully.",
                     "type":"success"
                 });
                 toastEvent.fire();
            }else{
                var toastEvent = $A.get("e.force:showToast");
                 toastEvent.setParams({
                     "title": "Error!",
                     "message": "Home Services were NOT UPDATED successfully.",
                     "type":"error"
                 });
                 toastEvent.fire();
                
                //console.log(JSON.stringify(response.getError()));
            }
            component.set("v.isLoading", false);
            
        })
        $A.enqueueAction(action);
	},
})