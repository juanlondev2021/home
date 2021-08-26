({
    saveEvent: function(component, event, helper) {
        var eventObj = {
            StartDateTime: component.find("start").get("v.value"),
            EndDateTime: component.find("end").get("v.value"),
            Description: component.find("description").get("v.value"),
            WhatId: component.get('v.HomeServiceId'),
            Home_Service__c: component.get('v.HomeServiceId'),
            IsPublic__c: false
        };
        if(eventObj.StartDateTime!=null && eventObj.EndDateTime!=null){
            component.set("v.showSpinner", true);
            helper.saveDataEvent(component, eventObj);
        }
    },
	openModel: function(component, event, helper) {
      // for Display Model,set the "isOpen" attribute to "true"
      component.set("v.isOpenEvent", true);
   },
 
   closeModel: function(component, event, helper) {
      // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
      component.set("v.isOpenEvent", false);
   },
 
})