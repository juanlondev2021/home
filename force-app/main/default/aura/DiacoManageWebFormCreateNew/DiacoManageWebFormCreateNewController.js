({
	doInit : function(component, event, helper) {
        component.set('v.isLoading', true);
        
        component.set('v.newWebForm', {'Book_Now_Date__c': undefined, 'Notes__c': undefined});
        
        var currentObject = component.get('v.currentObject');
        var currentInterests = [];
        if(currentObject.Interests__c){
            for(var label of currentObject.Interests__c.split(';')){
                currentInterests.push({'label': label, 'active': false});
            }
        }
        component.set('v.currentInterests', currentInterests);
        
        helper.gettingPickListValuesIntoList(component);
		
	},
    
    onSelect : function(component, event, helper) {
        var selected = event.target.dataset.value;
        
        var currentInterests = component.get('v.currentInterests');
        var allInterests = component.get('v.allInterests');
        
        var interestsToCreate = [];
       
        for(var inte of currentInterests){
            if(inte.label == selected){
                inte.active = !inte.active;
            }
            if(inte.active){
                interestsToCreate.push(inte.label);
            }
        }
        component.set('v.currentInterests', currentInterests);
        
        for(var inte of allInterests){
            if(inte.label == selected){
                inte.active = !inte.active;
            }
            if(inte.active){
                interestsToCreate.push(inte.label);
            }
        }
        component.set('v.allInterests', allInterests);
        
        //console.log(interestsToCreate);
        component.set('v.interestsToCreate', interestsToCreate);
        
        
	},
    
    onNext: function(component, event, helper) {
        if(!component.get('v.isOpenEdit')){
            var isChoosing = component.get('v.isChoosing');
            var interestsToCreate = component.get('v.interestsToCreate');
            var index = component.get('v.indexInterestsToCreate');
            
            if(isChoosing){
                component.set('v.isChoosing', false);
                component.set('v.indexInterestsToCreate', index + 1);
                component.set('v.currentInterestsToCreate', interestsToCreate[index + 1]);
                
                var currentObject = component.get('v.currentObject');
                var allInterests = component.get('v.allInterests');
                
                var new_ = "";
                var isChange = false;
                for(var item of allInterests){
                    if(item.active){
                        if(!isChange){
                            new_ += item.label;
                            isChange = true;
                        }else{
                            new_ += ";"+item.label
                        }
                    }
                }
                
                if(isChange){
                    if(currentObject.Interests__c){
                        currentObject.Interests__c = currentObject.Interests__c + ";" +new_;
                    }else{
                        currentObject.Interests__c = new_;
                    }
                    //console.log("Cambió");
                    //console.log(new_);
                    //console.log(currentObject.Interests__c);
                    
                    helper.savingAccount(component, {"Id": currentObject.Id, "Interests__c": currentObject.Interests__c});
                }
                   
            }else{
                //helper.creatingWebForm(component, )
                var items = component.find('inputField');
                if(items){
                    var allValid = items.reduce(function (validSoFar, inputCmp) {
                        inputCmp.showHelpMessageIfInvalid();
                        return validSoFar && inputCmp.checkValidity();
                    }, true);
                    if(allValid){
                        var newWebForm = component.get('v.newWebForm');
                        var currentObject = component.get('v.currentObject');
                        newWebForm.Account__c = currentObject.Id;
                        newWebForm.Interests__c = component.get('v.currentInterestsToCreate');
                        
                        component.set('v.isLoading', true);
                        helper.savingWebFormAndNext(component, newWebForm, index);
                    }
                } 
            } 	
        }else{
            component.set('v.isLoading', true);
            helper.savingWebFormAndNext(component, component.get('v.editObject'), 1);
        }
	},
    
    closeModel : function(component, event, helper) {
		component.set('v.isOpenCreate', false);
	},
})