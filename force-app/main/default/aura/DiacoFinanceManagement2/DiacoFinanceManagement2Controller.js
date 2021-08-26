({
    init: function(component, event, helper) {
        helper.getInitInfo(component);
    },
    
    activateSectionToUpdate: function(component, event, helper) {
        component.set("v.disableInput",!component.get("v.disableInput"));
        
        helper.showInformation(component, component.get('v.data'));
        component.set("v.notValidField",false);
                    
    },
    
    handleClick: function (component, event, helper) { 
        component.set("v.loaded ",true); 
        
        if(helper.validateFields(component)){
            console.log(helper.objectToSendInformation(component));
            helper.postAndUpdateInfo(component,helper.objectToSendInformation(component));
        }else{
            component.set("v.loaded",false);  
            component.set("v.notValidField",true);
        }        
    },
})